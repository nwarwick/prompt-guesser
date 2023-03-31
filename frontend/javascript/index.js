import "index.scss";
import "syntax-highlighting.css";
import "bridgetown-lit-renderer"

// Import all JavaScript & CSS files from src/_components
// To opt into `.global.css` & `.lit.css` nomenclature, change the `css` extension below to `global.css`.
// Read https://www.bridgetownrb.com/docs/components/lit#sidecar-css-files for documentation.
import components from "bridgetownComponents/**/*.{js,jsx,js.rb,css}";

console.info("Bridgetown is loaded!");

function handleGameStart() {
  console.info("working");
}
