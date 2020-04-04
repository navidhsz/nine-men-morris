defmodule MovementRules do
  @moduledoc false

  def valid_selection?(
        player_name,
        from_pos,
        from_pos_state
      )
      when from_pos_state == player_name do
    :ok
  end

  def valid_selection?(
        player_name,
        from_pos,
        from_pos_state
      )
      when from_pos_state == 0 do
    {:error, "position=#{from_pos} is empty. nothing to select"}
  end

  def valid_selection?(
        player_name,
        from_pos,
        from_pos_state
      )
      when from_pos_state == 0 do
    {:error, "position=#{from_pos} has a piece which belongs to the other player"}
  end

  def valid_destination?(player_name, to_pos, to_pos_state)
      when to_pos_state == 0 do
    :ok
  end

  def valid_destination?(player_name, to_pos, to_pos_state)
      when to_pos_state == player_name do
    {:error, "cannot move to position=#{to_pos}. you have a piece in this position"}
  end

  def valid_destination?(player_name, to_pos, to_pos_state) do
    {:error, "cannot move to position=#{to_pos}. the other player has a piece in this position"}
  end
end
