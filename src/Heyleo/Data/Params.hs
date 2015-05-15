{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Data.Params (
  makeParams,
  getParam,
  Params(getParams)
) where

import qualified Data.Map.Strict as M
import qualified Data.Text as T

newtype Params = Params { getParams :: M.Map T.Text String }

makeParams :: [(T.Text, T.Text)] -> Params
makeParams ps = Params $ M.map T.unpack $ M.fromList ps

getParam :: String -> String -> Params -> String
getParam k d pms = show $ M.findWithDefault d key params where
  key = T.pack k
  params = getParams pms
