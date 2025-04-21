#!/usr/bin/perl -w
use v5.12;
use lib 'lib';
use Test::More tests => 22;

use_ok( 'App::GUI::Spirograph::Settings' );
use_ok( 'App::GUI::Spirograph::Config' );
use_ok( 'App::GUI::Spirograph::Config::Default' );
use_ok( 'App::GUI::Spirograph::Compute::Mapping' );
use_ok( 'App::GUI::Spirograph::Compute::Image' );
use_ok( 'App::GUI::Spirograph::Dialog::About' );
use_ok( 'App::GUI::Spirograph::Widget::ProgressBar' );
use_ok( 'App::GUI::Spirograph::Widget::ColorDisplay' );
use_ok( 'App::GUI::Spirograph::Widget::PositionMarker' );
use_ok( 'App::GUI::Spirograph::Widget::SliderCombo' );
use_ok( 'App::GUI::Spirograph::Widget::SliderStep' );
use_ok( 'App::GUI::Spirograph::Frame::Panel::Board' );
use_ok( 'App::GUI::Spirograph::Frame::Panel::ColorBrowser' );
use_ok( 'App::GUI::Spirograph::Frame::Panel::ColorPicker' );
use_ok( 'App::GUI::Spirograph::Frame::Panel::ColorSetPicker' );
use_ok( 'App::GUI::Spirograph::Frame::Panel::Monomial' );
use_ok( 'App::GUI::Spirograph::Frame::Tab::Constraints' );
use_ok( 'App::GUI::Spirograph::Frame::Tab::Polynomial' );
use_ok( 'App::GUI::Spirograph::Frame::Tab::Mapping' );
use_ok( 'App::GUI::Spirograph::Frame::Tab::Color' );
use_ok( 'App::GUI::Spirograph::Frame' );
use_ok( 'App::GUI::Spirograph' );
