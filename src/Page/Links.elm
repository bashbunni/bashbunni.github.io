module Page.Links exposing (Model, Msg, init, update, view)

import Html exposing (..)



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view _ =
    div []
        [ text "welcome to my affiliate links" ]



-- LINKS
-- Need to add:
-- keyboard
-- amazon shop
--
