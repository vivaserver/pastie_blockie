class RevisionsController < ApplicationController
  before_filter :authorize, :only => [:edit, :destroy]
  
  # GET /blocks/1/revisions/1
  def show
    @block = Block.find(params[:block_id])
    @revision = @block.revisions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @revision }
    end
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  # GET /blocks/1/revisions/1/edit
  def edit
    @revision = Revision.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  # PUT /blocks/1/revisions/1
  def update
    @block = Block.find(params[:block_id])

    respond_to do |format|
      if @block.revisions.create(params[:revision])
        flash[:success] = 'Successfully added a new revision of your snippet.'
        format.html { redirect_to block_revision_path(@block,@block.latest_revision) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

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
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

private

  def authorize
    unless Block.find(params[:block_id]).signature == cookies[:signature]
      flash[:error] = 'This code snippet does not belong to you.'
      redirect_to blocks_url
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to blocks_url
  end
end
