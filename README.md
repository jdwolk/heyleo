Heyleo!
-------

Too lazy to open Trello to send messages to Leo???

Now you can keep bugging everyone's favorite Office Manager from the
comfort of Slack!

## Usage
(In slack)
```
/heyleo can we plz get some paper towels for the downstairs restroom? #kthxbai
```

## Setup

```
$ cabal install --only-dependencies && cabal configure && cabal build
```

### Slack

Visit [https://philosophie.slack.com/services/new/slash-commands](https://philosophie.slack.com/services/new/slash-commands).

Set the command to `/heyleo`, set the URL to your production server and method to `POST`. You should probably also keep the token given, though Heyleo isn't using it.

### Trello

#### Board ID

Go to your Trello board and pull out the board ID from the url segment:

`https://trello.com/b/<board-ID>/<board-name>`

#### Key

Go to [https://trello.com/app-key](https://trello.com/app-key) to retrieve the `key` needed for env vars below (you should probably also keep the `secret` given, but it's not required for Heyleo).

#### Token

You'll also need a non-expiring token for the board you'll be posting to.

You can get one by visiting the following URL and
authorizing read/write access to the board:

`https://trello.com/1/authorize?key=<api-key-here>&name=Heyleo&expiration=never&response_type=token&scope=read,write`

#### List ID

After you have the key, token, and board ID, you'll be able to retrieve the ID of the list of you'll be posting to on your target board.

Visit the following URL and get the appropriate list's ID:

`https://api.trello.com/1/boards/<board-id>/lists?cards=open&card_fields=name&fields=name&key=<trello-key>&token=<trello-token>`

### Env vars

Heyleo uses [dotenv-hs](https://github.com/stackbuilders/dotenv-hs) for reading
configuration into environment variables.

Create a file `./.env` and include the following variables:

```
TRELLO_KEY=...
TRELLO_TOKEN=...
BOARD_ID=...
LIST_ID=...
```

## Run

```
$ cabal run
```
