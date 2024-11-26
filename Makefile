help: ## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
			IFS=$$'#' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf "%-30s %s\n" $$help_command $$help_info ; \
	done

clean: ## Cleans Flutter project.  dart run build_runner build --delete-conflicting-outputs
	rm -f pubspec.lock
	rm -f ios/Podfile.lock
	flutter clean
	flutter pub get
	cd ios && pod repo update && pod install --verbose && cd ..
	dart run build_runner build --delete-conflicting-outputs

encode: ## Encode all .env files to base64 string
	base64 -i assets/env/development.env -o encodedDevEnvBase64.txt
	base64 -i assets/env/staging.env -o encodedStagEnvBase64.txt
	base64 -i assets/env/production.env -o encodedProdEnvBase64.txt

ipa-dev: ## Builds ipa
	flutter build ipa --flavor=development --target=lib/app/main.dev.dart --verbose

ipa-staging: ## Builds ipa
	flutter build ipa --flavor=staging --target=lib/app/main.qa.dart --verbose

ipa-prod: ## Builds ipa
	flutter build ipa --flavor=production --target=lib/app/main.prod.dart --verbose

apk-dev: ## Builds apk
	flutter build apk --flavor=development --target=lib/app/main.dev.dart --verbose 

apk-stag: ## Builds apk
	flutter build apk --flavor=staging --target=lib/app/main.qa.dart --verbose 

split-apk-dev: ## Builds apk
	flutter build apk --flavor=development --target=lib/app/main.dev.dart --verbose --split-per-abi

split-apk-staging: ## Builds apk
	flutter build apk --flavor=staging --target=lib/app/main.stag.dart --verbose --split-per-abi

dev-ios-release: ## Builds ios release
	flutter build ios --release --flavor=development --target=lib/app/main.dev.dart --verbose

stag-ios-release: ## Builds ios release
	flutter build ios --release --flavor=staging --target=lib/app/main.stag.dart --verbose

prod-ios-release: ## Builds ios release
	flutter build ios --release --flavor=production --target=lib/app/main.prod.dart --verbose

bundle-dev:
	flutter build appbundle --release --flavor=development --target=lib/app/main.prod.dart --verbose

codegen: ## Generate code
	dart run build_runner build --delete-conflicting-outputs