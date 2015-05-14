{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Slack.SlashMessage where

import Data.Aeson (withObject, FromJSON, (.:), parseJSON)
import Control.Applicative ((<$>), (<*>))

import Heyleo.Utils.Params (getParam, Params)
import Heyleo.Slack.SlashCommand (blankCommand, fromString, SlashCommand(..))

data SlashMessage = SlashMessage {
    token        :: String -- 'dslkfjDSLKJdflk123',
  , teamID       :: String -- 'TSH34HJD',
  , teamDomain   :: String -- 'philosophie',
  , channelID    :: String -- 'D03BHK09L',
  , channelName  :: String -- 'directmessage',
  , userID       :: String -- 'U03BHK094',
  , userName     :: String -- 'jdwolk',
  , command      :: SlashCommand -- '/heyleo',
  , msgText      :: String -- 'awesomeness'
} deriving (Show)

instance FromJSON SlashMessage where
  parseJSON = withObject "slashMessage" $ \o ->
    SlashMessage
      <$> o .: "token"
      <*> o .: "team_id"
      <*> o .: "team_domain"
      <*> o .: "channel_id"
      <*> o .: "channel_name"
      <*> o .: "user_id"
      <*> o .: "user_name"
      <*> o .: "command"
      <*> o .: "text"

-- TODO data type for fromParams, similar to fromJSON
-- TODO generic serialization???
-- TODO Reader monad for passing along params?
fromParams :: Params -> SlashMessage
fromParams params = SlashMessage {
  token       = getParam "token" "" params
, teamID      = getParam "team_id" "" params
, teamDomain  = getParam "team_domain" "" params
, channelID   = getParam "channel_id" "" params
, channelName = getParam "channel_name" "" params
, userID      = getParam "user_id" "" params
, userName    = getParam "user_name" "" params
, command     = fromString $ getParam "command" (show blankCommand) params
, msgText     = getParam "text" "" params
}

