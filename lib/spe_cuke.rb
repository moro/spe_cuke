module SpeCuke
  extend self

  def wrap_execute!(commands)
    puts commands.join(' ')
    system(*commands)
  end
end
