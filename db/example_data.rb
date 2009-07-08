module FixtureReplacement
  
  attributes_for :cuesheet do |u|
    u.performer              = "Steve Mac",
    u.title                  = "Essential Mix (2008-10-25) [TMB]",
    u.file                   = "Essential Mix - 2008-10-25 - Steve Mac.mp3"
  end

  attributes_for :track do |u|
    u.performer             = "Marc Houle",
    u.title                 = "Meatier Shower",
    u.minutes               = 1,
    u.seconds               = 41,
    u.frames                = 13
  end 

end

