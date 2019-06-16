class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: gzip
baseCommand:
  - gzip
inputs:
  - id: file
    type: File
    inputBinding:
      position: 0
outputs:
  - id: compressed
    type: stdout
label: gzip
requirements:
  - class: DockerRequirement
    dockerPull: 'ubuntu:latest'
stdout: $(inputs.file.basename).gz

