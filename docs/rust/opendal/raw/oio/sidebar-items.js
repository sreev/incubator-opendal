window.SIDEBAR_ITEMS = {"enum":[["PageOperation","PageOperation is the name for APIs of pager."],["ReadOperation","PageOperation is the name for APIs of pager."],["WriteOperation","WriteOperation is the name for APIs of Writer."]],"fn":[["into_streamable_reader","as_streamable is used to make [`oio::Read`] or [`oio::BlockingRead`] streamable."],["to_flat_pager","to_flat_pager is used to make a hierarchy pager flat."],["to_hierarchy_pager","to_hierarchy_pager is used to make a hierarchy pager flat."]],"mod":[["into_blocking_reader","into_blocking_reader will provide different implementations to convert into [`oio::BlockingRead`][crate::raw::oio::BlockingRead]"],["into_reader","into_reader will provide different implementations to convert into [`oio::Read`][crate::raw::oio::Read]"]],"struct":[["Cursor","Cursor is the cursor for [`Bytes`] that implements [`oio::Read`]"],["Entry","Entry is returned by `Page` or `BlockingPage` during list operations."],["IntoStreamableReader","Make given read streamable."],["ToFlatPager","ToFlatPager will walk dir in bottom up way:"],["ToHierarchyPager","ToHierarchyPager will convert a flat page to hierarchy by filter not needed entries."]],"trait":[["BlockingPage","BlockingPage is the blocking version of [`Page`]."],["BlockingRead","Read is the trait that OpenDAL returns to callers."],["BlockingWrite","BlockingWrite is the trait that OpenDAL returns to callers."],["Page","Page trait is used by [`crate::raw::Accessor`] to implement `list` or `scan` operation."],["Read","Read is the trait that OpenDAL returns to callers."],["ReadExt","Extension of [`Read`] to make it easier for use."],["Write","Write is the trait that OpenDAL returns to callers."]],"type":[["BlockingPager","BlockingPager is a boxed [`BlockingPage`]"],["BlockingReader","BlockingReader is a boxed dyn `BlockingRead`."],["BlockingWriter","BlockingWriter is a type erased [`BlockingWrite`]"],["Pager","The boxed version of [`Page`]"],["Reader","Reader is a type erased [`Read`]."],["Writer","Writer is a type erased [`Write`]"]]};