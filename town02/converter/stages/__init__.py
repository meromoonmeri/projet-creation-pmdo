"""Eight-stage converter pipeline.

Each stage is a callable that takes a Context and returns a StageResult.
No stage silently consumes errors: a stage that cannot honestly PASS
returns UNIMPLEMENTED/BLOCKED/UNKNOWN with a reason, and the pipeline
records that in the final report.
"""
