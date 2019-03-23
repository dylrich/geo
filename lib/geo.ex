defmodule Geo do
  @base_pixel_size 256
  @earth_radius 6_378_137
  @meters_per_inch 0.0254
  @to_rad :math.pi() / 180

  def haversine({lon1, lat1}, {lon2, lat2}) do
    dlon = d(lon2, lon1)
    dlat = d(lat2, lat1)

    a =
      :math.pow(dlat, 2) +
        :math.pow(dlon, 2) * :math.cos(lat1 * @to_rad) * :math.cos(lat2 * @to_rad)

    2 * @earth_radius * :math.asin(:math.sqrt(a))
  end

  def xy(z, lon, lat) do
    px = pixel(z, lon, lat)
    x = pixel_to_tile(elem(px, 0))
    y = pixel_to_tile(elem(px, 1))
    {x, y}
  end

  def pixel(z, lon, lat) do
    slat = :math.sin(lat * @to_rad)
    px = pixel_size(z)
    x = (lon + 180) / 360 * px
    y = (0.5 - :math.log10((1 + slat) / (1 - slat)) / (4 * :math.pi())) * px
    {x, y}
  end

  def scale(z, lat, dpi) do
    px = pixel_size(z)
    ground_dist = ground_distance(px, lat)
    scale = ground_dist * dpi / @meters_per_inch
    "1 : #{round(scale)}"
  end

  defp ground_distance(pixel_size, lat) do
    :math.cos(lat * @to_rad) * circumference(@earth_radius) / pixel_size
  end

  defp pixel_size(z) do
    @base_pixel_size * :math.pow(2, z)
  end

  defp circumference(r) do
    2 * :math.pi() * r
  end

  defp pixel_to_tile(pixel) do
    :math.floor(pixel / @base_pixel_size)
  end

  defp d(p1, p2) do
    :math.sin((p1 - p2) * @to_rad / 2)
  end
end
