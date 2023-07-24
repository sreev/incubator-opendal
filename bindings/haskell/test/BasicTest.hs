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
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module BasicTest (basicTests) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Data.HashMap.Strict as HashMap
import OpenDAL
import Test.Tasty
import Test.Tasty.HUnit

basicTests :: TestTree
basicTests =
  testGroup
    "Basic Tests"
    [ testCase "testBasicOperation" testRawOperation
    , testCase "testMonad" testMonad
    , testCase "testError" testError
    , testCase "testLayer" testLayer
    ]

testRawOperation :: Assertion
testRawOperation = do
  Right op <- newOp "memory" HashMap.empty
  writeOpRaw op "key1" "value1" >>= (@?= Right ())
  writeOpRaw op "key2" "value2" >>= (@?= Right ())
  readOpRaw op "key1" >>= (@?= Right "value1")
  readOpRaw op "key2" >>= (@?= Right "value2")
  isExistOpRaw op "key1" >>= (@?= Right True)
  isExistOpRaw op "key2" >>= (@?= Right True)
  createDirOpRaw op "dir1/" >>= (@?= Right ())
  isExistOpRaw op "dir1/" >>= (@?= Right True)
  copyOpRaw op "key1" "key3" >>= (@?= Right ())
  isExistOpRaw op "key1" >>= (@?= Right True)
  isExistOpRaw op "key3" >>= (@?= Right True)
  renameOpRaw op "key2" "key4" >>= (@?= Right ())
  isExistOpRaw op "key2" >>= (@?= Right False)
  isExistOpRaw op "key4" >>= (@?= Right True)
  statOpRaw op "key1" >>= \case
    Right meta -> meta @?= except_meta
    Left _ -> assertFailure "should not reach here"
  deleteOpRaw op "key1" >>= (@?= Right ())
  isExistOpRaw op "key1" >>= (@?= Right False)
  Right lister <- listOpRaw op "/"
  liftIO $ findLister lister "key3" >>= (@?= True)
  renameOpRaw op "key3" "/dir1/key5" >>= (@?= Right ())
  Right lister2 <- scanOpRaw op "/"
  liftIO $ findLister lister2 "dir1/key5" >>= (@?= True)
 where
  except_meta =
    Metadata
      { mMode = File
      , mCacheControl = Nothing
      , mContentDisposition = Nothing
      , mContentLength = 6
      , mContentMD5 = Nothing
      , mContentType = Nothing
      , mETag = Nothing
      , mLastModified = Nothing
      }

testMonad :: Assertion
testMonad = do
  Right op <- newOp "memory" HashMap.empty
  runOp op operation >>= (@?= Right ())
 where
  operation = do
    writeOp "key1" "value1"
    writeOp "key2" "value2"
    readOp "key1" ?= "value1"
    readOp "key2" ?= "value2"
    isExistOp "key1" ?= True
    isExistOp "key2" ?= True
    createDirOp "dir1/"
    isExistOp "dir1/" ?= True
    copyOp "key1" "key3"
    isExistOp "key1" ?= True
    isExistOp "key3" ?= True
    renameOp "key2" "key4"
    isExistOp "key2" ?= False
    isExistOp "key4" ?= True
    statOp "key1" ?= except_meta
    deleteOp "key1"
    isExistOp "key1" ?= False
    lister <- listOp "/"
    liftIO $ findLister lister "key3" ?= True
    renameOp "key3" "/dir1/key5"
    lister2 <- scanOp "/"
    liftIO $ findLister lister2 "dir1/key5" ?= True
  except_meta =
    Metadata
      { mMode = File
      , mCacheControl = Nothing
      , mContentDisposition = Nothing
      , mContentLength = 6
      , mContentMD5 = Nothing
      , mContentType = Nothing
      , mETag = Nothing
      , mLastModified = Nothing
      }

testError :: Assertion
testError = do
  Right op <- newOp "memory" HashMap.empty
  runOp op operation >>= \case
    Left err -> errorCode err @?= NotFound
    Right _ -> assertFailure "should not reach here"
 where
  operation = readOp "non-exist-path"

testLayer :: Assertion
testLayer = do
  Right op <- newOpWithLayers "memory" HashMap.empty [layer]
  runOp op operation >>= (@?= Right ())
 where
  layer = ImmutableIndex ["key1"]
  operation = do
    lister <- listOp "/"
    liftIO $ findLister lister "key1" ?= True

-- helper function

(?=) :: (MonadIO m, Eq a, Show a) => m a -> a -> m ()
result ?= except = result >>= liftIO . (@?= except)

findLister :: Lister -> String -> IO Bool
findLister lister key = do
  res <- nextLister lister
  case res of
    Left _ -> return False
    Right Nothing -> return False
    Right (Just k) -> if k == key then return True else findLister lister key