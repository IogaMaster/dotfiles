{sshKeyPath}: ''
  [user]
  	name = IogaMaster
  	email = iogamastercode@gmail.com
      signingkey = ${sshKeyPath}
  [pull]
  	rebase = true
  [init]
  	defaultBranch = main
  [filter "lfs"]
  	process = git-lfs filter-process
  	required = true
  	clean = git-lfs clean -- %f
  	smudge = git-lfs smudge -- %f
  [gpg]
      format = ssh
''
