{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Slack.SlashCommand (
  SlashCommand(..)
, fromString
, blankCommand
) where

import Data.Aeson (withText, FromJSON, parseJSON)
import Data.Text (unpack)

data SlashCommand = HeyleoCmd | OtherCmd deriving (Show)

-- I would make a custom Read instance,
-- but readsPrec / string parsers seem like overkill...
-- Why can't I just create a custom `read`???
fromString :: String -> SlashCommand
fromString "/heyleo" = HeyleoCmd
fromString  _        = OtherCmd

blankCommand :: SlashCommand
blankCommand = OtherCmd

instance FromJSON SlashCommand where
  parseJSON = withText "slashCommand" $ \s -> do
    return . fromString $ unpack s


