class RevisionsController < ApplicationController
  before_filter :authorize, :only => [:show, :edit, :destroy]
  
  # GET /blocks/1/revisions/1
  def show
    @block = Block.find(params[:block_id])
    @revision = @block.revisions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml
    end
  end

  # GET /blocks/1/revisions/1/edit
  def edit
    @revision = Revision.find(params[:id])
  end

  # PUT /blocks/1/revisions/1
  def update
    @block = Block.find(params[:block_id])
    @revision = @block.revisions.build(params[:revision])

    respond_to do |format|
      if @revision.save
        flash[:success] = 'Successfully added a new revision of your snippet.'
        format.html { redirect_to block_revision_path(@block,@block.latest_revision) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # updates just create new revisions
  alias :create :update

  # DELETE /blocks/1/revisions/1
  def destroy
    @revision = Revision.find(params[:id])
    @revision.destroy

    respond_to do |format|
      format.html do 
        if @revision.block.frozen?
          # last revision deleted, so also it's blocks' been deleted; redirect to remaining blocks listing
          redirect_to blocks_path
        else
          # some revisions left for block, redirect to latest
          redirect_to block_revision_path(@revision.block,@revision.block.latest_revision)           
        end
      end
      format.xml { head :ok }
    end
  end

private

  def authorize
    @block = Block.find(params[:block_id])
    @revision = @block.revisions.find(params[:id])

    if (action_name=='show' && @block.is_private && @block.signature != cookies[:signature]) || ((action_name=='destroy' || action_name=='update') && @block.signature != cookies[:signature])
      respond_to do |format|
        format.html { render :file => "#{RAILS_ROOT}/public/401.html", :status => :unauthorized }
        format.xml do 
          @block.errors.add_to_base('Unauthorized') # just to have some message to show
          render :xml => @block.errors, :status => :unauthorized 
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 }
      format.xml  { head 404 }
    end
  end

end
