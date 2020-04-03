
func printHelp() {
	fmt.Print(`usage:
	gdemo upload -file=<file path> [-name=<name>]
	gdemo reload -pkg=<jta file name> [-name=<name>]
`)
}

func main() {
	help := flag.Bool("help", false, "show help")

	// Subcommands
	uploadFlags := flag.NewFlagSet("upload", flag.ExitOnError)
	reloadFlags := flag.NewFlagSet("reload", flag.ExitOnError)

	pkgName := uploadFlags.String("name", "", "package name")
	file := uploadFlags.String("file", "", "file to be uploaded")

	name := reloadFlags.String("name", "", "demo name")
	pkg := reloadFlags.String("pkg", "", "name of the jta file")

	if len(os.Args) < 2 || *help {
		printHelp()
		fmt.Println("\nupload or reload subcommand is required")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "upload":
		uploadFlags.Parse(os.Args[2:])
	case "reload":
		reloadFlags.Parse(os.Args[2:])
	default:
		printHelp()
		os.Exit(1)
	}

	var err error
	if uploadFlags.Parsed() {
		if *file == "" {
			printHelp()
			os.Exit(1)
		}
	}

	if reloadFlags.Parsed() {
		if *pkg == "" {
			printHelp()
			os.Exit(1)
		}
	}
}
