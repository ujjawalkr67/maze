require "test_helper"

class MazePostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maze_post = maze_posts(:one)
  end

  test "should get index" do
    get maze_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_maze_post_url
    assert_response :success
  end

  test "should create maze_post" do
    assert_difference("MazePost.count") do
      post maze_posts_url, params: { maze_post: { description: @maze_post.description, public: @maze_post.public, title: @maze_post.title } }
    end

    assert_redirected_to maze_post_url(MazePost.last)
  end

  test "should show maze_post" do
    get maze_post_url(@maze_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_maze_post_url(@maze_post)
    assert_response :success
  end

  test "should update maze_post" do
    patch maze_post_url(@maze_post), params: { maze_post: { description: @maze_post.description, public: @maze_post.public, title: @maze_post.title } }
    assert_redirected_to maze_post_url(@maze_post)
  end

  test "should destroy maze_post" do
    assert_difference("MazePost.count", -1) do
      delete maze_post_url(@maze_post)
    end

    assert_redirected_to maze_posts_url
  end
end
