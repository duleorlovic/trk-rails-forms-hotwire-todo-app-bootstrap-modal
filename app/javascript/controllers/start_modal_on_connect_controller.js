import { Controller } from "stimulus"
import { Modal } from 'bootstrap'

// To open modal add this controller to .modal element, to close after submit
// add action close
//
// <div class="modal" tabindex="-1" data-controller='start-modal-on-connect'>
// ...
// <%= form.submit 'Update', 'data-action': 'start-modal-on-connect#close' %>

// Back button will load the modal again since <turbo-frame> contains .modal and
// src attribute (it will again load the .modal)
// so we need to remove .modal and clear src attribute
// https://turbo.hotwired.dev/handbook/building#preparing-the-page-to-be-cached
document.addEventListener("turbo:before-cache", function() {
  // remove modal since it will be opened automatically on connect
  // we need to do that by removing parent turbo-frame id='modal' which has src
  let modals = document.querySelectorAll('[data-controller="start-modal-on-connect"]')
  modals.forEach(function(modal) {
    let parentTurboFrame = modal.closest('turbo-frame')
    if (parentTurboFrame) {
      parentTurboFrame.innerHTML = ''
      parentTurboFrame.src = null
    } else {
      modal.remove()
    }
  })
})

export default class extends Controller {
  connect() {
    console.log('start-modal-on-connect#connect')
    let modal = new Modal(this.element)
    modal.show()
    // $(this.element).modal() // BS 4
  }

  close() {
    console.log('start-modal-on-connect#close')
    let modal = Modal.getInstance(this.element)
    modal.hide()
    // $(this.element).modal('hide') // BS 4
  }

  disconnect() {
    console.log('start-modal-on-connect#disconnect')
    // at this stage page it is already cached and it is about to be replaced
  }
}
