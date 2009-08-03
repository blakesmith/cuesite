class CuesheetController < ApplicationController

  def new
    @cuesheet = Cuesheet.new
  end

  def upload_cuesheet
    cue_file = params[:cue_file]
    cue = Cuesheet.load_from_file(cue_file.read, cue_file.original_filename)
    render :text => 'Cuesheet successfully uploaded' if cue
  end

end
