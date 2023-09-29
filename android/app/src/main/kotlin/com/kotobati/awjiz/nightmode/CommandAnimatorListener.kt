package com.kotobati.awjiz.nightmode

import android.animation.Animator
import com.kotobati.awjiz.nightmode.service.FilterService


class CommandAnimatorListener(
    private val cmd: Command,
    private val svc: FilterService
) : Animator.AnimatorListener {

    override fun onAnimationStart(a: Animator) = cmd.onAnimationStart(svc)
    override fun onAnimationEnd(a: Animator) = cmd.onAnimationEnd(svc)
    override fun onAnimationCancel(a: Animator) = cmd.onAnimationCancel(svc)
    override fun onAnimationRepeat(a: Animator) = cmd.onAnimationRepeat(svc)


}
