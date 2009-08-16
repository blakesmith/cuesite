class CuesheetsController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
    @cuesheets = Cuesheet.all
  end

  def new
    @cuesheet = Cuesheet.new
  end

  def create
    if params[:cue_file]
      cue_file = params[:cue_file]
      cue = Cuesheet.load_from_file(cue_file.read, cue_file.original_filename)
      if cue
        flash[:notice] = 'Cuesheet successfully uploaded!'
        redirect_to :action => :show, :id => cue.id
      else
        flash.now[:error] = 'Cuesheet failed to upload'
        render :action => :new
      end
    else
      flash.now[:error] = 'You didn\'t select a cuesheet to upload'
      render :action => :new
    end
  end

  def show
    if params[:id]
      @cuesheet = Cuesheet.find(params[:id], :include => {:tracks => :song})
    end
  end

  def destroy
    cuesheet = Cuesheet.find(params[:id])
    if cuesheet.delete
      flash.now[:notice] = 'Cuesheet successfully removed!'
    else
      flash.now[:error] = 'Cuesheet failed to remove.'
    end
    list
    render :action => 'list'
  end

  def export
    cue = Cuesheet.find(params[:id])
    if cue
      send_data(cue.to_cuesheet, {:filename => cue.cue_file})
    end
  end

end
