module Page.Links exposing (..)

import Browser.Navigation as Nav
import Html exposing (..)


type alias Model =
    { key : Nav.Key
    }


init : Nav.Key -> ( Model, Cmd Msg )
init key =
    ( Model key, Cmd.none )


type Msg
    = Content String


update : Msg -> Model -> Model
update _ model =
    model


view : Model -> Html Msg
view _ =
    div []
        [ text "welcome to my affiliate links" ]
