module Page.About exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Url.Builder exposing (absolute)



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
view model =
    div []
        [ div []
            [ links
                (internalLinkList navLinks)
            ]
        , div
            []
            [ typing model
            , section [ class "output" ]
                [ links (externalLinkList socialLinks)
                , about
                , interests
                ]
            , credit
            ]
        ]


typing : Model -> Html Msg
typing _ =
    div [ class "typeme" ]
        [ span [ class "text-secondary" ] [ text "bashbunni@bunnibrain " ]
        , span [ class "text-background" ] [ text " ~ " ]
        , span [ class "cursor" ] [ text " $ " ]
        , text "me -h"
        ]



-- NAV


navLinks : List Link
navLinks =
    [ Link "blog" (absolute [ "blog" ] [])
    , Link "links" (absolute [ "links" ] [])
    ]


internalLinkList : List Link -> List (Html Msg)
internalLinkList items =
    items
        |> List.map
            (\link ->
                li []
                    [ a
                        [ class link.name
                        , href link.url
                        , alt link.name
                        ]
                        [ text link.name ]
                    ]
            )



-- SOCIAL LINKS


type alias Link =
    { name : String
    , url : String
    }


socialLinks : List Link
socialLinks =
    [ Link "twitch" "https://twitch.tv/bashbunni"
    , Link "youtube" "https://youtube.com/bashbunni"
    , Link "github" "https://github.com/bashbunni"
    , Link "mastodon" "https://mastodon.social/@bashbunni"
    , Link "twitter" "https://twitter.com/sudobunni"
    ]


links : List (Html Msg) -> Html Msg
links htmlList =
    ul [ class "links" ] htmlList


externalLinkList : List Link -> List (Html Msg)
externalLinkList items =
    items
        |> List.map
            (\link ->
                li []
                    [ a
                        [ class link.name
                        , href link.url
                        , alt link.name
                        , target "_blank"
                        ]
                        [ text link.name ]
                    ]
            )



-- CONTENT


about : Html Msg
about =
    div []
        [ text "I'm a software developer and content creator who builds mostly with Go. I'm also currently learning Rust which is top tier ~fabulous~."
        , p []
            [ text " I hack on open source projects in public on my Twitch channel. I also have a "
            , a
                [ class "youtube"
                , href "https://youtube.com/bashbunni"
                , alt "bashbunni's youtube channel"
                , target "_blank"
                ]
                [ text " YouTube" ]
            , text " channel where I post more curated content on what I'm learning. I love long form content because I know social media platforms can feel like a highlight reel of people's lives, but I like that long form gives you space to share the challenges and messy parts of learning."
            ]
        , p [] [ text " My goal for my platforms is to foster community. I want to create a space that leaves you feeling excited and inspired around software. I'm not perfect, I've got lots of things to learn and skills to develop, but I put myself out there anyway. I learn new things in front of an audience so people can see the *real* process of building skills and not just the highlights. I strive to support the developer community and empower others to pursue challenge and stay curious." ]
        ]


interests : Html Msg
interests =
    div []
        [ div []
            [ span
                [ class "text-secondary"
                ]
                [ text "bashbunni@bunnibrain " ]
            , span
                [ class "text-background"
                ]
                [ text " ~ " ]
            , span
                [ class "cursor"
                ]
                [ text " $ " ]
            , text "glow interests.md"
            ]
        , h3 [] [ text "Interests" ]
        , ul []
            [ li [] [ text "linux (hence, bashbunni)" ]
            , li [] [ text "terminals and terminal tools" ]
            , li [] [ text "backend development" ]
            , li []
                [ text "cyber security" ]
            ]
        ]


credit : Html Msg
credit =
    footer []
        [ text "This site was styled with the"
        , a
            [ href "https://github.com/catppuccin"
            , alt "catppuccin github"
            , target "_blank"
            ]
            [ text " Catppuccin theme" ]
        ]
