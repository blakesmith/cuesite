class CuesheetController < ApplicationController

  def index
    @cuesheets = Cuesheet.all
  end

  def new
    @cuesheet = Cuesheet.new
  end

  def create
    cue_file = params[:cue_file]
    cue = Cuesheet.load_from_file(cue_file.read, cue_file.original_filename)
    if cue
      flash[:notice] = 'Cuesheet successfully uploaded!'
      redirect_to :action => :show, :id => cue.id
    else
      flash[:error] = 'Cuesheet failed to upload'
      render :action => :new
    end
  end

  def show
    if params[:id]
      @cuesheet = Cuesheet.find(params[:id])
    end
  end

end
