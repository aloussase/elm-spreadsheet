# elm-spreadsheet

This is a basic spreadsheet made with Elm for educational purposes.

See it at: https://aloussase.github.io/elm-spreadsheet.

## Features

- Enter a number in a cell
- Add the contents of a cell to a number
- Add the contents of a cell to another cell

## Building

To compile the elm code and generate the corresponding javascript in the
`public` directory:
```bash
make prod
```

## Running

After building, you can spawn an http server in the `public` directory to try the
page. For example:
```bash
python -m http.server --dir=public
```

## License

MIT
