-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing,
-- software distributed under the License is distributed on an
-- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
-- KIND, either express or implied.  See the License for the
-- specific language governing permissions and limitations
-- under the License.
{-# LANGUAGE FlexibleInstances #-}

{- |
Module      : OpenDAL
Description : Haskell bindings for OpenDAL
Copyright   : (c) 2023 OpenDAL
License     : Apache-2.0
Maintainer  : OpenDAL Contributors <dev@opendal.apache.org>"
Stability   : experimental
Portability : non - portable (GHC extensions)

This module provides Haskell bindings for OpenDAL.
-}
module OpenDAL (
  Operator,
  Lister,
  OpenDALError (..),
  ErrorCode (..),
  EntryMode (..),
  Metadata (..),
  OpMonad,
  MonadOperation (..),
  runOp,
  newOp,
  readOpRaw,
  writeOpRaw,
  isExistOpRaw,
  createDirOpRaw,
  copyOpRaw,
  renameOpRaw,
  deleteOpRaw,
  statOpRaw,
  listOpRaw,
  scanOpRaw,
  nextLister,
) where

import Control.Monad.Except (ExceptT, runExceptT, throwError)
import Control.Monad.Reader (ReaderT, ask, liftIO, runReaderT)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HashMap
import Data.Time (UTCTime, parseTimeM, zonedTimeToUTC)
import Data.Time.Format (defaultTimeLocale)
import Foreign
import Foreign.C.String
import OpenDAL.FFI

{- | `Operator` is the entry for all public blocking APIs.
Create an `Operator` with `newOp`.
-}
newtype Operator = Operator (ForeignPtr RawOperator)

{- | `Lister` is designed to list entries at given path in a blocking manner.
Users can construct Lister by `listOp` or `scanOp`.
-}
newtype Lister = Lister (ForeignPtr RawLister)

-- | Represents the possible error codes that can be returned by OpenDAL.
data ErrorCode
  = -- | An error occurred in the FFI layer.
    FFIError
  | -- | OpenDAL don't know what happened here, and no actions other than just returning it back. For example, s3 returns an internal service error.
    Unexpected
  | -- | Underlying service doesn't support this operation.
    Unsupported
  | -- | The config for backend is invalid.
    ConfigInvalid
  | -- | The given path is not found.
    NotFound
  | -- | The given path doesn't have enough permission for this operation.
    PermissionDenied
  | -- | The given path is a directory.
    IsADirectory
  | -- | The given path is not a directory.
    NotADirectory
  | -- | The given path already exists thus we failed to the specified operation on it.
    AlreadyExists
  | -- | Requests that sent to this path is over the limit, please slow down.
    RateLimited
  | -- | The given file paths are same.
    IsSameFile
  deriving (Eq, Show)

-- | Represents an error that can occur when using OpenDAL.
data OpenDALError = OpenDALError
  { errorCode :: ErrorCode
  -- ^ The error code.
  , message :: String
  -- ^ The error message.
  }
  deriving (Eq, Show)

-- | Represents the mode of an entry in a storage system (e.g., file or directory).
data EntryMode = File | Dir | Unknown deriving (Eq, Show)

-- | Represents metadata for an entry in a storage system.
data Metadata = Metadata
  { mMode :: EntryMode
  -- ^ The mode of the entry.
  , mCacheControl :: Maybe String
  -- ^ The cache control of the entry.
  , mContentDisposition :: Maybe String
  -- ^ The content disposition of the entry.
  , mContentLength :: Integer
  -- ^ The content length of the entry.
  , mContentMD5 :: Maybe String
  -- ^ The content MD5 of the entry.
  , mContentType :: Maybe String
  -- ^ The content type of the entry.
  , mETag :: Maybe String
  -- ^ The ETag of the entry.
  , mLastModified :: Maybe UTCTime
  -- ^ The last modified time of the entry.
  }
  deriving (Eq, Show)

-- | The monad used for OpenDAL operations.
type OpMonad = ReaderT Operator (ExceptT OpenDALError IO)

-- | A type class for monads that can perform OpenDAL operations.
class (Monad m) => MonadOperation m where
  -- | Read the whole path into a bytes.
  readOp :: String -> m ByteString

  -- | Write bytes into given path.
  writeOp :: String -> ByteString -> m ()

  -- | Check if this path exists or not.
  isExistOp :: String -> m Bool

  -- | Create a dir at given path.
  createDirOp :: String -> m ()

  -- | Copy a file from srcPath to dstPath.
  copyOp :: String -> String -> m ()

  -- | Rename a file from srcPath to dstPath.
  renameOp :: String -> String -> m ()

  -- | Delete given path.
  deleteOp :: String -> m ()

  -- | Get given path’s metadata without cache directly.
  statOp :: String -> m Metadata

  -- | List current dir path.
  -- This function will create a new handle to list entries.
  -- An error will be returned if path doesn’t end with /.
  listOp :: String -> m Lister

  -- | List dir in flat way.
  -- Also, this function can be used to list a prefix.
  -- An error will be returned if given path doesn’t end with /.
  scanOp :: String -> m Lister

instance MonadOperation OpMonad where
  readOp path = do
    op <- ask
    result <- liftIO $ readOpRaw op path
    either throwError return result
  writeOp path byte = do
    op <- ask
    result <- liftIO $ writeOpRaw op path byte
    either throwError return result
  isExistOp path = do
    op <- ask
    result <- liftIO $ isExistOpRaw op path
    either throwError return result
  createDirOp path = do
    op <- ask
    result <- liftIO $ createDirOpRaw op path
    either throwError return result
  copyOp src dst = do
    op <- ask
    result <- liftIO $ copyOpRaw op src dst
    either throwError return result
  renameOp src dst = do
    op <- ask
    result <- liftIO $ renameOpRaw op src dst
    either throwError return result
  deleteOp path = do
    op <- ask
    result <- liftIO $ deleteOpRaw op path
    either throwError return result
  statOp path = do
    op <- ask
    result <- liftIO $ statOpRaw op path
    either throwError return result
  listOp path = do
    op <- ask
    result <- liftIO $ listOpRaw op path
    either throwError return result
  scanOp path = do
    op <- ask
    result <- liftIO $ scanOpRaw op path
    either throwError return result

-- helper functions

byteSliceToByteString :: ByteSlice -> IO ByteString
byteSliceToByteString (ByteSlice bsDataPtr len) = BS.packCStringLen (bsDataPtr, fromIntegral len)

parseErrorCode :: Int -> ErrorCode
parseErrorCode 1 = FFIError
parseErrorCode 2 = Unexpected
parseErrorCode 3 = Unsupported
parseErrorCode 4 = ConfigInvalid
parseErrorCode 5 = NotFound
parseErrorCode 6 = PermissionDenied
parseErrorCode 7 = IsADirectory
parseErrorCode 8 = NotADirectory
parseErrorCode 9 = AlreadyExists
parseErrorCode 10 = RateLimited
parseErrorCode 11 = IsSameFile
parseErrorCode _ = FFIError

parseEntryMode :: Int -> EntryMode
parseEntryMode 0 = File
parseEntryMode 1 = Dir
parseEntryMode _ = Unknown

parseCString :: CString -> IO (Maybe String)
parseCString value | value == nullPtr = return Nothing
parseCString value = do
  value' <- peekCString value
  free value
  return $ Just value'

parseTime :: String -> Maybe UTCTime
parseTime time = zonedTimeToUTC <$> parseTimeM True defaultTimeLocale "%Y-%m-%dT%H:%M:%S%Q%z" time

parseFFIMetadata :: FFIMetadata -> IO Metadata
parseFFIMetadata (FFIMetadata mode cacheControl contentDisposition contentLength contentMD5 contentType eTag lastModified) = do
  let mode' = parseEntryMode $ fromIntegral mode
  cacheControl' <- parseCString cacheControl
  contentDisposition' <- parseCString contentDisposition
  let contentLength' = toInteger contentLength
  contentMD5' <- parseCString contentMD5
  contentType' <- parseCString contentType
  eTag' <- parseCString eTag
  lastModified' <- (>>= parseTime) <$> parseCString lastModified
  return $
    Metadata
      { mMode = mode'
      , mCacheControl = cacheControl'
      , mContentDisposition = contentDisposition'
      , mContentLength = contentLength'
      , mContentMD5 = contentMD5'
      , mContentType = contentType'
      , mETag = eTag'
      , mLastModified = lastModified'
      }

-- Exported functions

-- | Runs an OpenDAL operation in the 'OpMonad'.
runOp :: Operator -> OpMonad a -> IO (Either OpenDALError a)
runOp operator op = runExceptT $ runReaderT op operator

-- | Creates a new OpenDAL operator via `HashMap`.
newOp :: String -> HashMap String String -> IO (Either OpenDALError Operator)
newOp scheme hashMap = do
  let keysAndValues = HashMap.toList hashMap
  withCString scheme $ \cScheme ->
    withMany withCString (map fst keysAndValues) $ \cKeys ->
      withMany withCString (map snd keysAndValues) $ \cValues ->
        allocaArray (length keysAndValues) $ \cKeysPtr ->
          allocaArray (length keysAndValues) $ \cValuesPtr ->
            alloca $ \ffiResultPtr -> do
              pokeArray cKeysPtr cKeys
              pokeArray cValuesPtr cValues
              c_via_map_ffi cScheme cKeysPtr cValuesPtr (fromIntegral $ length keysAndValues) ffiResultPtr
              ffiResult <- peek ffiResultPtr
              if ffiCode ffiResult == 0
                then do
                  op <- Operator <$> newForeignPtr c_free_operator (dataPtr ffiResult)
                  return $ Right op
                else do
                  let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
                  errMsg <- peekCString (errorMessage ffiResult)
                  return $ Left $ OpenDALError code errMsg

-- Functions for performing raw OpenDAL operations are defined below.
-- These functions are not meant to be used directly in most cases.
-- Instead, use the high-level interface provided by the 'MonadOperation' type class.

-- | Read the whole path into a bytes.
readOpRaw :: Operator -> String -> IO (Either OpenDALError ByteString)
readOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_read opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then do
          byteslice <- peek $ dataPtr ffiResult
          byte <- byteSliceToByteString byteslice
          c_free_byteslice (bsData byteslice) (bsLen byteslice)
          return $ Right byte
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

-- | Write bytes into given path.
writeOpRaw :: Operator -> String -> ByteString -> IO (Either OpenDALError ())
writeOpRaw (Operator op) path byte = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    BS.useAsCStringLen byte $ \(cByte, len) ->
      alloca $ \ffiResultPtr -> do
        c_blocking_write opptr cPath cByte (fromIntegral len) ffiResultPtr
        ffiResult <- peek ffiResultPtr
        if ffiCode ffiResult == 0
          then return $ Right ()
          else do
            let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
            errMsg <- peekCString (errorMessage ffiResult)
            return $ Left $ OpenDALError code errMsg

-- | Check if this path exists or not.
isExistOpRaw :: Operator -> String -> IO (Either OpenDALError Bool)
isExistOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_is_exist opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then do
          val <- peek $ dataPtr ffiResult
          let isExist = val /= 0
          return $ Right isExist
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

-- | Create a dir at given path.
createDirOpRaw :: Operator -> String -> IO (Either OpenDALError ())
createDirOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_create_dir opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then return $ Right ()
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

-- | Copy a file from srcPath to dstPath.
copyOpRaw :: Operator -> String -> String -> IO (Either OpenDALError ())
copyOpRaw (Operator op) srcPath dstPath = withForeignPtr op $ \opptr ->
  withCString srcPath $ \cSrcPath ->
    withCString dstPath $ \cDstPath ->
      alloca $ \ffiResultPtr -> do
        c_blocking_copy opptr cSrcPath cDstPath ffiResultPtr
        ffiResult <- peek ffiResultPtr
        if ffiCode ffiResult == 0
          then return $ Right ()
          else do
            let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
            errMsg <- peekCString (errorMessage ffiResult)
            return $ Left $ OpenDALError code errMsg

-- | Rename a file from srcPath to dstPath.
renameOpRaw :: Operator -> String -> String -> IO (Either OpenDALError ())
renameOpRaw (Operator op) srcPath dstPath = withForeignPtr op $ \opptr ->
  withCString srcPath $ \cSrcPath ->
    withCString dstPath $ \cDstPath ->
      alloca $ \ffiResultPtr -> do
        c_blocking_rename opptr cSrcPath cDstPath ffiResultPtr
        ffiResult <- peek ffiResultPtr
        if ffiCode ffiResult == 0
          then return $ Right ()
          else do
            let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
            errMsg <- peekCString (errorMessage ffiResult)
            return $ Left $ OpenDALError code errMsg

-- | Delete given path.
deleteOpRaw :: Operator -> String -> IO (Either OpenDALError ())
deleteOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_delete opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then return $ Right ()
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

-- | Get given path’s metadata without cache directly.
statOpRaw :: Operator -> String -> IO (Either OpenDALError Metadata)
statOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_stat opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then do
          ffimatadata <- peek $ dataPtr ffiResult
          metadata <- parseFFIMetadata ffimatadata
          return $ Right metadata
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

{- | List current dir path.
This function will create a new handle to list entries.
An error will be returned if path doesn’t end with /.
-}
listOpRaw :: Operator -> String -> IO (Either OpenDALError Lister)
listOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_list opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then do
          ffilister <- peek $ dataPtr ffiResult
          lister <- Lister <$> newForeignPtr c_free_lister ffilister
          return $ Right lister
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

{- | List dir in flat way.
Also, this function can be used to list a prefix.
An error will be returned if given path doesn’t end with /.
-}
scanOpRaw :: Operator -> String -> IO (Either OpenDALError Lister)
scanOpRaw (Operator op) path = withForeignPtr op $ \opptr ->
  withCString path $ \cPath ->
    alloca $ \ffiResultPtr -> do
      c_blocking_scan opptr cPath ffiResultPtr
      ffiResult <- peek ffiResultPtr
      if ffiCode ffiResult == 0
        then do
          ffilister <- peek $ dataPtr ffiResult
          lister <- Lister <$> newForeignPtr c_free_lister ffilister
          return $ Right lister
        else do
          let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
          errMsg <- peekCString (errorMessage ffiResult)
          return $ Left $ OpenDALError code errMsg

-- | Get next entry path from `Lister`.
nextLister :: Lister -> IO (Either OpenDALError (Maybe String))
nextLister (Lister lister) = withForeignPtr lister $ \listerptr ->
  alloca $ \ffiResultPtr -> do
    c_lister_next listerptr ffiResultPtr
    ffiResult <- peek ffiResultPtr
    if ffiCode ffiResult == 0
      then do
        val <- peek $ dataPtr ffiResult
        Right <$> parseCString val
      else do
        let code = parseErrorCode $ fromIntegral $ ffiCode ffiResult
        errMsg <- peekCString (errorMessage ffiResult)
        return $ Left $ OpenDALError code errMsg