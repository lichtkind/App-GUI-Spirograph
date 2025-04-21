#

package App::GUI::Spirograph::Frame::Tab::Shape;
use v5.12;
use warnings;
use Wx;
use base qw/Wx::Panel/;
use App::GUI::Wx::Widget::Custom::SliderStep;
use App::GUI::Wx::Widget::Custom::SliderCombo;

my $default_settings = {
};

sub new {
    my ( $class, $parent) = @_;
    my $self = $class->SUPER::new( $parent, -1);
    $self->{'callback'} = sub {};


    $self->{'label'}{'outer_shape'} = Wx::StaticText->new($self, -1, ' E n c l o s u r e   O u t e r   P o l y g o n :' );
    $self->{'label'}{'gear_shape'} = Wx::StaticText->new($self, -1, ' G e a r   S h a p e :' );
    $self->{'label'}{'pen_pos'} = Wx::StaticText->new($self, -1, ' P e n   P o s i t i o n :' );
  # $self->{'lbl_consta'} = Wx::StaticText->new($self, -1, 'A : ' );

  # $self->{'type'} = Wx::RadioBox->new( $self, -1, ' T y p e ', [-1,-1], [-1, -1], ['Mandelbrot', 'Julia', 'Any'] );
  # $self->{'coor_as_start'} = Wx::CheckBox->new( $self, -1, ' Start Value', [-1,-1], [-1, -1]);

  # $self->{'zoom'}        = Wx::TextCtrl->new( $self, -1, 1, [-1,-1], [ 80, -1] );
  # $self->{'reset_zoom'}  = Wx::Button->new( $self, -1, 1, [-1,-1], [ 30, -1] );
  # $self->{'button_zoom'} = App::GUI::Wx::Widget::Custom::SliderStep->new( $self, 150, 3, 0.3, 2, 2);
  # $self->{'stop_nr'}     = App::GUI::Wx::Widget::Custom::SliderCombo->new( $self, 365, 'Count:', "Square root of maximal amount of iterations run on one pixel coordinates", 3, 120, 5, 0.25);
  # $self->{'stop_metric'} = Wx::ComboBox->new( $self, -1, '|var|', [-1,-1],[95, -1], ['|var|', '|x|+|y|', '|x|', '|y|', '|x+y|', 'x+y', 'x-y', 'y-x', 'x*y', '|x*y|']);

  # $self->{'button_zoom'}->SetToolTip('zoom factor: the larger the more you zoom in');
  # $self->{'button_zoom'}->SetCallBack(sub {  });
  # $self->{'const_widgets'} = [qw/const_a const_b button_ca button_cb lbl_const lbl_consta lbl_constb reset_const_a reset_const_b /];


    # Wx::Event::EVT_BUTTON( $self, $self->{'reset_zoom'},     sub { $self->{'zoom'}->SetValue(1) });
    # Wx::Event::EVT_RADIOBOX( $self, $self->{'type'},  sub { $self->{'callback'}->(); });
    # Wx::Event::EVT_CHECKBOX( $self, $self->{'coor_as_monom'}, sub {    });
    # Wx::Event::EVT_TEXT( $self, $self->{$_},          sub { $self->{'callback'}->() }) for qw/zoom center_x center_y const_a const_b start_a start_b/;
    # Wx::Event::EVT_COMBOBOX( $self, $self->{$_},      sub { $self->{'callback'}->() }) for qw/stop_metric/;

    my $std  = &Wx::wxALIGN_LEFT | &Wx::wxALIGN_CENTER_VERTICAL | &Wx::wxGROW;
    my $box  = $std | &Wx::wxTOP | &Wx::wxBOTTOM;
    my $item = $std | &Wx::wxLEFT;
    my $row  = $std | &Wx::wxTOP;
    my $all  = $std | &Wx::wxALL;
    my $left_margin = 20;

    my $type_sizer = Wx::BoxSizer->new(&Wx::wxHORIZONTAL);
    $type_sizer->AddSpacer( $left_margin );
    $type_sizer->AddSpacer( 40 );
    # $type_sizer->Add( $coor_sizer,            0, $item, 30);
    $type_sizer->AddStretchSpacer( );

    my $sizer = Wx::BoxSizer->new(&Wx::wxVERTICAL);
    $sizer->AddSpacer( 10 );
    $sizer->Add( $self->{'label'}{'outer_shape'},  0, $item, $left_margin);
    $sizer->Add( Wx::StaticLine->new( $self, -1), 0, $box, 10 );
    $sizer->Add( $self->{'label'}{'gear_shape'},  0, $item, $left_margin);
    $sizer->Add( Wx::StaticLine->new( $self, -1), 0, $box, 10 );
    $sizer->Add( $self->{'label'}{'pen_pos'},  0, $item, $left_margin);
    $sizer->Add( $type_sizer,      0, $row, 10);
    $sizer->AddSpacer(  3 );
    $sizer->Add( Wx::StaticLine->new( $self, -1), 0, $box, 10 );
    $sizer->AddSpacer( $left_margin );
    $self->SetSizer($sizer);

    $self->init();
    $self;
}

sub init         { $_[0]->set_settings ( $default_settings ) }
sub set_settings {
    my ( $self, $settings ) = @_;
    return 0 unless ref $settings eq 'HASH' and exists $settings->{'type'};
    $self->PauseCallBack();
    for my $key (qw//){
        next unless exists $settings->{$key} and exists $self->{$key};
        $self->{$key}->SetValue( $settings->{$key} );
    }
    for my $key (qw//){
        next unless exists $settings->{$key} and exists $self->{$key};
        $self->{$key}->SetSelection( $self->{$key}->FindString($settings->{$key}) );
    }
    $self->set_coordinates_as_factor( $settings->{'coor_as_monom'} );
    $self->set_type( $settings->{'type'} );
    $self->update_iter_count();
    $self->RestoreCallBack();
    1;
}
sub get_settings {
    my ( $self ) = @_;
    return {
#        coor_as_start => int $self->{'coor_as_start'}->GetValue,
 #        zoom     => $self->{'zoom'}->GetValue  + 0,
#        stop_metric => $self->{'stop_metric'}->GetStringSelection,
    }
}

sub SetCallBack {
    my ($self, $code) = @_;
    return unless ref $code eq 'CODE';
    $self->{'callback'} = $code;
}
sub PauseCallBack {
    my ($self) = @_;
    return if $self->CallBackiIsPaused;
    $self->{'paused_call'} = $self->{'callback'};
    $self->{'callback'} = sub {};
}
sub CallBackiIsPaused { exists $_[0]->{'paused_call'} }
sub RunCallBack      { $_[0]->{'callback'}->() }
sub RestoreCallBack {
    my ($self) = @_;
    return unless $self->CallBackiIsPaused;
    $self->{'callback'} = $self->{'paused_call'};
    delete $self->{'paused_call'};
}

1;
