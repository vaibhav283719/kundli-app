package com.vaibhav.kundli.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.google.android.gms.ads.AdRequest
import com.vaibhav.kundli.R
import com.vaibhav.kundli.data.local.prefs.AppPreferences
import com.vaibhav.kundli.databinding.FragmentHomeBinding
import com.vaibhav.kundli.util.AdManager
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class HomeFragment : Fragment() {

    private var _binding: FragmentHomeBinding? = null
    private val binding get() = _binding!!
    private val viewModel: HomeViewModel by viewModels()

    @Inject lateinit var adManager: AdManager
    @Inject lateinit var prefs: AppPreferences

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.tvWelcome.text = "Namaste, ${viewModel.getUserName()}! 🙏"

        binding.cardKundli.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_birthDetailsFragment)
        }

        binding.cardHoroscope.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_horoscopeFragment)
        }

        binding.cardCompatibility.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_compatibilityFragment)
        }

        binding.cardRemedies.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_remediesFragment)
        }

        binding.cardKundliList.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_kundliListFragment)
        }

        binding.cardPremium.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_premiumFragment)
        }

        binding.cardSettings.setOnClickListener {
            findNavController().navigate(R.id.action_homeFragment_to_settingsFragment)
        }

        setupBannerAd()
    }

    private fun setupBannerAd() {
        if (prefs.isPremium) {
            binding.adView.isVisible = false
            return
        }
        binding.adView.loadAd(AdRequest.Builder().build())
    }

    override fun onResume() {
        super.onResume()
        if (!prefs.isPremium) binding.adView.resume()
    }

    override fun onPause() {
        if (!prefs.isPremium) binding.adView.pause()
        super.onPause()
    }

    override fun onDestroyView() {
        binding.adView.destroy()
        super.onDestroyView()
        _binding = null
    }
}
