module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Content String


update : Msg -> Model -> Model
update _ model =
    model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ typing model
        , section [ class "output" ]
            [ links model
            , about
            , interests
            ]
        , credit
        ]


typing : Model -> Html Msg
typing _ =
    div [ class "typeme" ]
        [ span [ class "text-secondary" ] [ text "bashbunni@bunnibrain " ]
        , span [ class "text-background" ] [ text " ~ " ]
        , span [ class "cursor" ] [ text " $ " ]
        , text "me -h"
        ]


type alias Link =
    { name : String
    , url : String
    }


socials : List Link
socials =
    [ Link "twitch" "https://twitch.tv/bashbunni"
    , Link "youtube" "https://youtube.com/bashbunni"
    , Link "github" "https://github.com/bashbunni"
    , Link "mastodon" "https://mastodon.social/@bashbunni"
    , Link "twitter" "https://twitter.com/sudobunni"
    ]


links : Model -> Html Msg
links _ =
    ul [ class "links" ] (renderUl socials)


renderUl : List Link -> List (Html Msg)
renderUl items =
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


about : Html Msg
about =
    div []
        [ text "I'm a software developer and content creator who builds mostly with Go. I do developer relations at"
        , a
            [ class "charm"
            , href "https://charm.sh"
            , alt "charm website"
            , target "_blank"
            ]
            [ text " @charmcli" ]
        , text " which is top tier ~fabulous~."
        , p [] [ text " I hack on open source projects (my own, Charm's, and others) in public on my Twitch channel. I also have a YouTube channel where I post more curated content on what I'm learning. I love long form content because I resent how social media platforms can feel like a highlight reel of people's lives, when in reality, we all struggle, especially when coding (heh)." ]
        , p [] [ text " My goal for my platforms is that I can help bring people closer to their goals by leading by example. I'm not perfect, I've got lots of things to learn and skills to develop, but I put myself out there anyway. I learn new things in front of an audience so people can see the *real* process of building skills and not just the highlights." ]
        , p [] [ text " My goal is to show that achieving your goals is doable but takes dedication and I hope to continue to inspire and motivate people with my content." ]
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
