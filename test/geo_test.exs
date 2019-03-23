defmodule GeoTest do
  use ExUnit.Case
  doctest Geo

  test "haversine distance works" do
    p1 = {-35.98, 32.11}
    p2 = {120.91, -45.67}
    assert Geo.haversine(p1, p2) == 17_545_308.851116184
  end

  test "pixel xy coordinates work" do
    south_africa = {22.9375, -30.5595}
    lon = elem(south_africa, 0)
    lat = elem(south_africa, 1)
    px = {1154.4888888888888, 1103.3593947992722}
    assert Geo.pixel(3, lon, lat) == px
  end

  test "tile xy coordinates work" do
    south_africa = {22.9375, -30.5595}
    lon = elem(south_africa, 0)
    lat = elem(south_africa, 1)
    assert Geo.xy(3, lon, lat) == {4, 4}
  end

  test "scale works" do
    south_africa = {22.9375, -30.5595}
    lat = elem(south_africa, 1)
    assert Geo.scale(3, lat, 96) == "1 : 63684785"
  end
end
