require "application_system_test_case"

class MazePostsTest < ApplicationSystemTestCase
  setup do
    @maze_post = maze_posts(:one)
  end

  test "visiting the index" do
    visit maze_posts_url
    assert_selector "h1", text: "Maze posts"
  end

  test "should create maze post" do
    visit maze_posts_url
    click_on "New maze post"

    fill_in "Description", with: @maze_post.description
    check "Public" if @maze_post.public
    fill_in "Title", with: @maze_post.title
    click_on "Create Maze post"

    assert_text "Maze post was successfully created"
    click_on "Back"
  end

  test "should update Maze post" do
    visit maze_post_url(@maze_post)
    click_on "Edit this maze post", match: :first

    fill_in "Description", with: @maze_post.description
    check "Public" if @maze_post.public
    fill_in "Title", with: @maze_post.title
    click_on "Update Maze post"

    assert_text "Maze post was successfully updated"
    click_on "Back"
  end

  test "should destroy Maze post" do
    visit maze_post_url(@maze_post)
    click_on "Destroy this maze post", match: :first

    assert_text "Maze post was successfully destroyed"
  end
end
