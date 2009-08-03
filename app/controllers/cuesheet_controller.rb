class CuesheetController < ApplicationController

  def new
    @cuesheet = Cuesheet.new
  end

  def upload_cuesheet
    cue = params[:cue_file]
    File.open(Rails.root.join('public', 'uploads', cue.original_filename), 'w') do |file|
      file.write(cue.read)
    end
    render :text => 'Cuesheet successfully uploaded' if cue
  end

end
