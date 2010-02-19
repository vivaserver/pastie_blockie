require 'test_helper'

class BlocksControllerTest < ActionController::TestCase
  
  test "index with only public blocks" do
    get :index
    assert_response :success
    # a random signature cookie should be in order
    assert_not_nil cookies['signature']
    # just one public block, so just one table row
    assert_not_nil assigns(:blocks)
    assert_select 'table tr', 1
  end

  test "index including private blocks" do
    @request.cookies['signature'] = '435Ryo5W2R0y65Q5etcMLw=='
    get :index
    assert_response :success
    # one public block & one own private block, so two table rows
    assert_not_nil assigns(:blocks)
    assert_select 'table tr', 2
  end
  
  # tests for showing
  
  test "trying to show a non-existing block renders a 404 error" do
    get :show, :id => 1234567890
    assert_response 404
  end

  test "do not show private blocks to non-owners" do
    get :show, :id => blocks(:private).to_param
    assert_response :unauthorized
  end
  
  test "always show block along it's latest revision" do
    get :show, :id => blocks(:public).to_param
    assert_response :success
    assert_not_nil assigns(:block)
    assert_select 'pre'
  end
  
  # tests for creating

  test "creation of a block should allow the entering of it's first revision" do
    get :new
    assert_response :success
    assert_not_nil cookies['signature']
    assert_not_nil assigns(:block)
    assert_not_nil assigns(:revision)
    # verify existance of proper element for the Block.revisions_attributes method to work
    assert_select 'form #block_revisions_attributes_0_snippet'
  end

  test "always create a block along it's first revision" do
    assert_difference('Block.count') do
      post :create, :block => { :language_id => 1, :is_private => 0, :revisions_attributes => [:snippet => 'some code snippet'] }
    end
    assert_redirected_to blocks_path
  end

  # tests for editing

  test "do not allow the editing of someone else's blocks" do
    get :edit, :id => blocks(:private).to_param
    assert_response :unauthorized
  end
  
  test "trying to edit a block redirects to the editing of it's latest revision" do
    @request.cookies['signature'] = '435Ryo5W2R0y65Q5etcMLw=='
    block = blocks(:private)
    get :edit, :id => block
    assert_redirected_to edit_block_revision_path(block,block.latest_revision)
  end

  # test for destroying

  test "do not allow the destruction of someone else's blocks" do
    delete :destroy, :id => blocks(:public).to_param
    assert_response :unauthorized
  end
  
  test "only destruction of own blocks allowed" do
    @request.cookies['signature'] = 'wqYRrQ+Gi0cS9XfOLL62Tw=='
    assert_difference('Block.count', -1) do
      delete :destroy, :id => blocks(:public).to_param
    end
    assert_redirected_to blocks_url
  end

end
