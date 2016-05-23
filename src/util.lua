return {
  
  -- Sets the mouse visibility
  setMouseVisibility = function(level) 
  if level:isFinished() == 0 and _gui:drawGame() then 
    love.mouse.setVisible(false);
  else
    love.mouse.setVisible(true);
  end
end

}