module Page.Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (alt, class, href)
import Json.Decode exposing (Decoder, int, list, map3, string)


type alias Model =
    { blog : Blog }


displayPosts : Model -> Html Msg
displayPosts model =
    model.blog.items
        |> List.map
            (\item ->
                [ a
                    [ class "blog-link"
                    , href item.url
                    , alt item.title
                    ]
                    [ text item.title ]
                ]
            )


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    -- read json file
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


view : Model -> Html Msg
view _ =
    div [] [ text "welcome to my blog" ]


type alias Blog =
    { title : String
    , author : String
    , items : List Post
    }



-- blogDecoder: decode json into Blog type


blogDecoder : Decoder Blog
blogDecoder =
    map3 Blog
        (field "title" string)
        (field "title" string)
        (field "items" (list postDecoder))


type alias Post =
    { id : Int
    , url : String
    , title : String
    , content : String
    , datePublished : String
    }


postDecoder : Decoder Post
postDecoder =
    map5 Post
        (field "id" int)
        (field "url" string)
        (field "title" string)
        (field "content_html" string)
        (field "date_published" string)



-- TODOs
-- TODO list of blog posts, routing to each page
-- need loading state?
-- TODO figure out how to init THIS model; does it start empty, then fetch posts from
-- init, to handle in update?
--
