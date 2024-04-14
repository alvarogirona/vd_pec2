import vegaEmbed from "vega-embed";
const PiePlot = {
    mounted() {
        this.props = { id: this.el.getAttribute("data-id") };
        this.handleEvent(`pie_plot:${this.props.id}:init`, ({ spec }) => {
            vegaEmbed(this.el, spec)
                .then((result) => result.view)
                .catch((error) => console.error(error));
        });
    },
};

export default PiePlot;