{{- define "go-webapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "go-webapp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "go-webapp.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "go-webapp.labels" -}}
app.kubernetes.io/name: {{ include "go-webapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "go-webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "go-webapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "go-webapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (printf "%s-sa" (include "go-webapp.fullname" .)) .Values.serviceAccount.name -}}
{{- else -}}
{{- required "serviceAccount.name is required when serviceAccount.create=false" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "go-webapp.secretStoreName" -}}
{{- default (printf "%s-secretstore" (include "go-webapp.fullname" .)) .Values.externalSecrets.secretStore.name -}}
{{- end -}}

{{- define "go-webapp.externalSecretTargetName" -}}
{{- default (printf "%s-postgres" (include "go-webapp.fullname" .)) .Values.externalSecrets.targetSecret.name -}}
{{- end -}}

{{- define "go-webapp.externalSecretsServiceAccountName" -}}
{{- default (include "go-webapp.serviceAccountName" .) .Values.externalSecrets.secretStore.aws.serviceAccountRefName -}}
{{- end -}}
