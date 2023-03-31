import { LitElement, html, css } from "lit"

export class HappyDaysElement extends LitElement {
  static styles = css`
    :host {
      display: block;
      border: 2px dashed gray;
      padding: 20px;
      max-width: 300px;
    }
  `

  static properties = {
    hello: { type: String }
  }

  render() {
    return html`
      <button @click="${this.increment}">Hello ${this.hello}! ${Date.now()}</button>
    `;
  }

  increment(e) {
    console.info('working!')
  }
}



// Try adding `<%= lit :happy_days, hello: "there" %>` somewhere in an ERB template
// on your site to see this example Lit component in action!
customElements.define("happy-days", HappyDaysElement)
