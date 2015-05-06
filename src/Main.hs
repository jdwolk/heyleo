{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Monoid
import Data.Maybe (fromMaybe)
import Web.Spock.Safe
import System.Environment (lookupEnv)

main :: IO ()
main = do
    maybePort <- lookupEnv "PORT"
    port <- return $ read $ fromMaybe "8080" maybePort
    runSpock port $ spockT id $
      do get root $
             text "Hello World!"
         get ("hello" <//> var) $ \name ->
             text ("Hello " <> name <> "!")
