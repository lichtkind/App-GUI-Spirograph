
# compute fractal image

package App::GUI::Spirograph::Compute::Image;
use v5.12;
use warnings;
use Benchmark;
use Graphics::Toolkit::Color qw/color/;
use Wx;
use App::GUI::Wx::Widget::Custom::ProgressBar;
use App::GUI::Spirograph::Compute::Mapping;

use constant SKETCH_FACTOR => 4;
# 'π' => 3.1415926535,  'τ' => 6.2831853071795,

my %progress_bar;
sub add_progress_bar {
    my( $name, $bar ) = @_;
    $progress_bar{$name} = $bar
        if ref $bar eq 'App::GUI::Spirograph::Widget::ProgressBar'
        and not exists $progress_bar{$name};
}

sub compute_colors {
    my( $set, $max_iter ) = @_;
    my (@color_object, %gradient_mapping, $gradient_total_length, @color_value, $background_color);

    if ($set->{'mapping'}{'custom_partition'}){
        %gradient_mapping = %{ App::GUI::Spirograph::Compute::Mapping::scales(
            $set->{'mapping'}{'scale_distro'}, $max_iter, $set->{'mapping'}{'scale_steps'}
        )};
        $gradient_total_length = $set->{'mapping'}{'scale_steps'};
    } else {
        $gradient_total_length = $max_iter;
    }

    if ($set->{'mapping'}{'user_colors'}){
        my $begin_nr = substr $set->{'mapping'}{'begin_color'}, 6;
        my $end_nr = substr $set->{'mapping'}{'end_color'}, 6;
        my $gradient_bases = 1 + abs( $begin_nr - $end_nr );

        my $gradient_part_length = ($gradient_bases == 1)
                                 ?  $gradient_total_length
                                 : 1 + int($gradient_total_length / ($gradient_bases - 1 ));
        my $gradient_direction = ( $begin_nr <= $end_nr ) ? 1 : -1;
        my $color_nr = $begin_nr;
        @color_object = map {color( $set->{'color'}{$color_nr} )} 1 .. $gradient_total_length if $gradient_bases == 1;
        for (1 .. $gradient_bases - 1) {
            my $start_color = color( $set->{'color'}{$color_nr} );
            $color_nr += $gradient_direction;
            # last partial gradient has to full it up to the end
            $gradient_part_length = $gradient_total_length - @color_object if $color_nr == $end_nr;
            push @color_object, $start_color->gradient( to => $set->{'color'}{ $color_nr },
                                                     steps => $gradient_part_length,
                                                        in => $set->{'mapping'}{'gradient_space'},
                                                   dynamic => $set->{'mapping'}{'gradient_dynamic'} );
            pop @color_object if $color_nr != $end_nr;
        }
        $background_color = (substr($set->{'mapping'}{'background_color'}, 0, 5) eq 'color')
                          ? $set->{'color'}{'1'}
                          : $set->{'mapping'}{'background_color'};
        $background_color = '#001845' if $background_color eq 'blue';
        $background_color = color( $background_color );
    } else {
        @color_object = color('white')->gradient( to => 'black', steps => $max_iter,
                                                  in => $set->{'mapping'}{'gradient_space'},
                                             dynamic => $set->{'mapping'}{'gradient_dynamic'} );
        $background_color = $color_object[ -1 ];
    }

    if ($set->{'mapping'}{'use_subgradient'}){
        push @color_object, $color_object[-1];
        my %subgradient_mapping = %{ App::GUI::Spirograph::Compute::Mapping::scales(
             $set->{'mapping'}{'subgradient_distro'},
             $set->{'mapping'}{'subgradient_size'},
             $set->{'mapping'}{'subgradient_steps'},
        )};
        for my $subgradient_nr (1 .. $max_iter) {
            my @subgradient = $color_object[$subgradient_nr - 1]->gradient(
                                              to => $color_object[$subgradient_nr],
                                           steps => $set->{'mapping'}{'subgradient_steps'},
                                              in => $set->{'mapping'}{'subgradient_space'},
                                         dynamic => $set->{'mapping'}{'subgradient_dynamic'} );
            my @subcolor = map { [$_->values( 'RGB' )] } @subgradient;
            $color_value[$subgradient_nr - 1][$_] = $subcolor[ $subgradient_mapping{$_} ]
                    for 0 .. $set->{'mapping'}{'subgradient_size'} - 1;
        }
    } else {
        @color_value = map { [$_->values( 'RGB' )] } @color_object;
        if (%gradient_mapping){
            my @temp_color = @color_value;
            $color_value[$_] = $temp_color[ $gradient_mapping{$_} ] for 0 .. $max_iter-1;
        }
    }

    return \@color_value, [ $background_color->values( 'RGB' ) ];
}

sub from_settings {
    my( $set, $size, $sketch ) = @_;
    my $img = Wx::Image->new( $size->{'x'}, $size->{'y'} );
    my $sketch_factor = (defined $sketch) ? SKETCH_FACTOR : 0;
    my $t0 = Benchmark->new();

    my @code = (
        '',
    );

    my $code = join '', map { $_ . ";\n"} @code;
    eval $code;
    die "bad iter code - $@ :\n$code" if $@; # say $code;
    say "compile:",timestr(timediff(Benchmark->new, $t0));

    return $img;
}

1;

__END__
$img->SetRGB( $px+'.$x.', $py+'.$y.', @$color)
