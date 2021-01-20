{{- with secret "int-pki/issue/example-dot-com" "common_name=blah.example.com" -}}
{{ .Data.certificate }}{{ end }}
