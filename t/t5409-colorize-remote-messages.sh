#!/bin/sh

test_description='remote messages are colorized on the client'

. ./test-lib.sh

test_expect_success 'setup' '
	mkdir .git/hooks &&
	cat << EOF > .git/hooks/update &&
#!/bin/sh
echo error: error
echo hint: hint
echo success: success
echo warning: warning
exit 0
EOF
	chmod +x .git/hooks/update &&
	echo 1 >file &&
	git add file &&
	git commit -m 1 &&
	git clone . child &&
	cd child &&
	echo 2 > file &&
	git commit -a -m 2
'

test_expect_success 'push' 'git -c color.remote=always push origin HEAD:refs/heads/newbranch 2>output &&
  test_decode_color < output > decoded &&
  test_i18ngrep "<BOLD;RED>error<RESET>:" decoded &&
  test_i18ngrep "<YELLOW>hint<RESET>:" decoded &&
  test_i18ngrep "<BOLD;GREEN>success<RESET>:" decoded &&
  test_i18ngrep "<BOLD;YELLOW>warning<RESET>:" decoded'

test_done
