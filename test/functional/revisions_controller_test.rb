require 'test_helper'

class RevisionsControllerTest < ActionController::TestCase
  # test "should update block" do
  #   put :update, :id => blocks(:one).to_param, :block => { }
  #   assert_redirected_to block_path(assigns(:block))
  # end
  
  # tests for showing

  test "trying to show a non-existing revision renders a 404 error" do
    get :show, :id => 1234567890
    assert_response 404
  end

  test "trying to show an existing revision of non-existing block also renders a 404 error" do
    get :show, :id => revisions(:public_rev).to_param, :block_id => 1234567890
    assert_response 404
  end

  test "do not show revisions belonging to private blocks to non-owners" do
    revision = revisions(:private_rev2)
    get :show, :id => revision, :block_id => revision.block
    assert_response :unauthorized
  end

  test "show single revision but also links to all remaining for current block" do
    @request.cookies['signature'] = '435Ryo5W2R0y65Q5etcMLw=='
    revision = revisions(:private_rev1)
    get :show, :id => revision, :block_id => revision.block
    assert_response :success
    assert_not_nil assigns(:block)
    assert_not_nil assigns(:revision)
    assert_select 'pre'
    assert_select 'ul#revs li', 2
  end
  
  # tests for editing

  test "do not allow the editing of revisions belonging to private blocks to non-owners" do
    revision = revisions(:private_rev2)
    get :edit, :id => revision, :block_id => revision.block
    assert_response :unauthorized
  end

  test "only allow revision editing to block owner" do
    @request.cookies['signature'] = '435Ryo5W2R0y65Q5etcMLw=='
    revision = revisions(:private_rev2)
    get :edit, :id => revision, :block_id => revision.block
    assert_response :success
    assert_not_nil assigns(:revision)
  end  
  
  # test for creating
  
  test "create a revision only for existing own block" do
    @request.cookies['signature'] = '435Ryo5W2R0y65Q5etcMLw=='
    revision = revisions(:private_rev2)
    assert_difference('Revision.count') do
      post :create, :id => revision.id, :block_id => revision.block.id, :revision => { :snippet => 'some code snippet' }
    end
    assert_redirected_to block_revision_path(revision.block, revision.block.latest_revision)
  end

  # tests for destroying
  
  test "do not allow the destruction of someone else's revisions" do
    revision = revisions(:public_rev)
    delete :destroy, :block_id => revision.block, :id => revision
    assert_response :unauthorized
  end

  test "only destruction of own revisions allowed" do
    @request.cookies['signature'] = '435Ryo5W2R0y65Q5etcMLw=='
    revision = revisions(:private_rev2)
    assert_difference('Revision.count', -1) do
      delete :destroy, :block_id => revision.block, :id => revision
    end
    assert_redirected_to block_revision_path(revision.block, revision.block.latest_revision)
  end
  
  test "destroying last block revision also destroys block and redirects to home" do
    @request.cookies['signature'] = 'wqYRrQ+Gi0cS9XfOLL62Tw=='
    revision = revisions(:public_rev)
    assert_difference('Block.count', -1) do
      delete :destroy, :block_id => revision.block, :id => revision
    end
    assert_redirected_to blocks_path
  end

end
