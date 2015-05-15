{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Slack.SlashMessage (
  SlashMessage(..),
  fromParams
) where

import Data.Aeson (withObject, FromJSON, (.:), parseJSON)
import Control.Applicative ((<$>), (<*>))
import Heyleo.Data.Message (Message(sender, text))
import Heyleo.Data.Params (getParam, Params)
import Heyleo.Slack.SlashCommand (blankCommand, fromString, SlashCommand(..))

data SlashMessage = SlashMessage {
    token        :: String -- 'dslkfjDSLKJdflk123',
  , teamID       :: String -- 'TSH34HJD',
  , teamDomain   :: String -- 'philosophie',
  , channelID    :: String -- 'DLKJAD9874',
  , channelName  :: String -- 'directmessage',
  , userID       :: String -- 'LKJD98UK',
  , userName     :: String -- 'superdude',
  , command      :: SlashCommand -- '/heyleo',
  , msgText      :: String -- 'make me a sammich'
} deriving (Show)

instance Message SlashMessage where
  sender = userName
  text = msgText

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
  token       = read $ getParam "token" "" params
, teamID      = read $ getParam "team_id" "" params
, teamDomain  = read $ getParam "team_domain" "" params
, channelID   = read $ getParam "channel_id" "" params
, channelName = read $ getParam "channel_name" "" params
, userID      = read $ getParam "user_id" "" params
, userName    = read $ getParam "user_name" "" params
, command     = fromString $ getParam "command" (show blankCommand) params
, msgText     = read $ getParam "text" "" params
}

