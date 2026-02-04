import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    this.deferredPrompt = null
    this.registerServiceWorker()
    this.setupInstallPrompt()
  }

  registerServiceWorker() {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/service-worker', { scope: '/' })
        .then((registration) => {
          console.log('[PWA] Service Worker registered:', registration.scope)
        })
        .catch((error) => {
          console.error('[PWA] Service Worker registration failed:', error)
        })
    }
  }

  setupInstallPrompt() {
    window.addEventListener('beforeinstallprompt', (event) => {
      event.preventDefault()
      this.deferredPrompt = event
      console.log('[PWA] Install prompt ready')

      if (this.isMobileDevice() && !this.wasPromptDismissed()) {
        this.showBanner()
      }
    })

    window.addEventListener('appinstalled', () => {
      console.log('[PWA] App installed successfully')
      this.hideBanner()
      this.deferredPrompt = null
    })
  }

  isMobileDevice() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
           (window.innerWidth <= 768)
  }

  wasPromptDismissed() {
    const dismissed = localStorage.getItem('pwa-install-dismissed')
    if (!dismissed) return false

    const dismissedDate = new Date(dismissed)
    const daysSinceDismissed = (Date.now() - dismissedDate.getTime()) / (1000 * 60 * 60 * 24)
    return daysSinceDismissed < 7
  }

  showBanner() {
    if (this.hasBannerTarget) {
      this.bannerTarget.classList.add('show')
    }
  }

  hideBanner() {
    if (this.hasBannerTarget) {
      this.bannerTarget.classList.remove('show')
    }
  }

  install() {
    if (!this.deferredPrompt) {
      console.log('[PWA] No install prompt available')
      return
    }

    this.deferredPrompt.prompt()
    this.deferredPrompt.userChoice.then((choiceResult) => {
      if (choiceResult.outcome === 'accepted') {
        console.log('[PWA] User accepted install')
      } else {
        console.log('[PWA] User dismissed install')
      }
      this.deferredPrompt = null
      this.hideBanner()
    })
  }

  dismiss() {
    localStorage.setItem('pwa-install-dismissed', new Date().toISOString())
    this.hideBanner()
  }
}
