defmodule CompanionWeb.PipelineInstrumenter do
  @moduledoc """
  Metrics instrumenter for plug pipeline
  """
  use Prometheus.PlugPipelineInstrumenter
end
