class SongsController < ApplicationController

  def show
    @song = Song.find(params[:id])
    @remixes = @song.all_remixes
    @cuesheets = @song.all_cuesheets
    if params[:from]
      @cuesheet = Cuesheet.find params[:from]
    end

  end

  def update
    respond_to do |format|
      format.js do
        render :update do |page|
          @song = Song.find_or_create_by_performer_and_title(params[:song][:performer], params[:song][:title])
          @track = Track.find(params[:track])
          @track.update_attributes(:song_id => @song.id)
          if @song.save
            page.replace "song_#{params[:id]}", :partial => 'cuesheets/song_row', :object => @track
          end
        end
      end
    end
  end

end
