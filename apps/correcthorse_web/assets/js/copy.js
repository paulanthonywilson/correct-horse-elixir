let copy = document.getElementById("copy-generated-password")
let password = document.getElementById("generated-password")
let copied = document.getElementById("copied")

if(null != copy) {
    const clipboard = require('clipboard-copy')
    copy.addEventListener("click", e => {
        clipboard(password.value)
        copied.classList.remove("hidden")
        e.preventDefault()
    })
}