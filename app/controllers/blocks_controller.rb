class BlocksController < ApplicationController
  before_filter :authorize, :only => [:edit, :destroy]
  
  # GET /blocks
  # GET /blocks.xml
  def index
    @blocks = Block.viewable(cookies[:signature],params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blocks }
    end
  end

  # GET /blocks/1
  # GET /blocks/1.xml
  def show
    @block = Block.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @block }
    end
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  # GET /blocks/new
  # GET /blocks/new.xml
  def new
    @block = Block.new
    @revisions = @block.revisions.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @block }
    end
  end

  # GET /blocks/1/edit
  def edit
    @block = Block.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  # POST /blocks
  # POST /blocks.xml
  def create
    @block = Block.new(params[:block])

    respond_to do |format|
      if @block.save        
        flash[:success] = 'Your '+(@block.is_private ? '<strong>private</strong>' : 'anonymous')+' code snippet was successfully created.'
        format.html { redirect_to(@block) }
        format.xml  { render :xml => @block, :status => :created, :location => @block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blocks/1
  # PUT /blocks/1.xml
  def update
    @block = Block.find(params[:id])

    respond_to do |format|
      if @block.update_attributes(params[:block])
        flash[:success] = 'Your code snippet was successfully updated.'
        format.html { redirect_to(@block) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.xml
  def destroy
    @block = Block.find(params[:id])
    @block.destroy

    respond_to do |format|
      format.html { redirect_to(blocks_url) }
      format.xml  { head :ok }
    end
  end

private

  def authorize
    unless Block.find(params[:id]).signature == cookies[:signature]
      flash[:error] = 'This code snippet does not belong to you.'
      redirect_to blocks_url
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to blocks_url
  end
end