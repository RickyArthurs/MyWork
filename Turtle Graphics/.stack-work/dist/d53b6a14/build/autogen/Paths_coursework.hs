{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_coursework (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Workspace\\Haskell\\2465714A\\.stack-work\\install\\47555bef\\bin"
libdir     = "C:\\Workspace\\Haskell\\2465714A\\.stack-work\\install\\47555bef\\lib\\x86_64-windows-ghc-9.0.2\\coursework-0.1.0.0-A91iCr7y4Q7AUyzEOaOhke"
dynlibdir  = "C:\\Workspace\\Haskell\\2465714A\\.stack-work\\install\\47555bef\\lib\\x86_64-windows-ghc-9.0.2"
datadir    = "C:\\Workspace\\Haskell\\2465714A\\.stack-work\\install\\47555bef\\share\\x86_64-windows-ghc-9.0.2\\coursework-0.1.0.0"
libexecdir = "C:\\Workspace\\Haskell\\2465714A\\.stack-work\\install\\47555bef\\libexec\\x86_64-windows-ghc-9.0.2\\coursework-0.1.0.0"
sysconfdir = "C:\\Workspace\\Haskell\\2465714A\\.stack-work\\install\\47555bef\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "coursework_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "coursework_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "coursework_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "coursework_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "coursework_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "coursework_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
