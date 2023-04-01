import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game"
export default class extends Controller {
  connect() {
    console.info('Working!')
    console.log('Working!')
  }

  
  generate() {
    // Generate text prompt
    // Generate image prompt
    // Update interface
    console.info('Working!')
    console.log('Working!')
  }

  // curl https://api.openai.com/v1/images/generations \
  // -H "Content-Type: application/json" \
  // -H "Authorization: Bearer $OPENAI_API_KEY" \
  // -d '{
  //   "prompt": "a white siamese cat",
  //   "n": 1,
  //   "size": "1024x1024"
  // }'
  generateImage() {
    
  }

}
