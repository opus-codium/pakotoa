import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this)
    })
  }
  end(event) {
    let url = event.from.dataset.dragUrl
    let id = event.item.dataset.id
    let data = new FormData()
    data.append("position", event.newIndex + 1)
    fetch(url.replace(':id', id), {
      method: 'PATCH',
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: data
    })
  }
}
